using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient; // SQL baðlantýsý için gerekli kütüphane
using Microsoft.Extensions.Configuration; // Ayarlarý okumak için gerekli

namespace RiskTrakWeb.Controllers
{
    public class CustomerController : Controller
    {
        // 1. EKSÝK OLAN KISIM BURASIYDI: Deðiþkeni tanýmlýyoruz
        private readonly string _connectionString;

        // 2. CONSTRUCTOR (KURUCU METOT): Proje açýlýnca burasý çalýþýr ve ayarý okur
        public CustomerController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        // --- LÝSTELEME (INDEX) ---
        public IActionResult Index()
        {
            DataTable dt = new DataTable();

            // Veritabanýna baðlanýp verileri çekiyoruz
            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                con.Open();
                string query = "SELECT * FROM Customer";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                da.Fill(dt);
            }

            // Veriyi sayfaya gönderiyoruz (Burasý boþ olursa hata alýrsýn!)
            return View(dt);
        }

        // --- EKLEME SAYFASI (CREATE GET) ---
        [HttpGet]
        public IActionResult Create()
        {
            return View();
        }

        // --- EKLEME ÝÞLEMÝ (CREATE POST - SP Kullanýmý) ---
        [HttpPost]
        public IActionResult Create(string name, string industry, string address, string email, string phone, string taxno)
        {
            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                // Step 3'te yazdýðýmýz Stored Procedure'ü çaðýrýyoruz
                SqlCommand cmd = new SqlCommand("sp_AddNewCustomer", con);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Industry", industry);
                cmd.Parameters.AddWithValue("@Address", address);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@TaxNo", taxno);

                con.Open();
                cmd.ExecuteNonQuery();
            }
            return RedirectToAction("Index");
        }

        // --- SÝLME ÝÞLEMÝ (DELETE) ---
        [HttpPost]
        public IActionResult Delete(int id)
        {
            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                // Basit silme sorgusu
                string query = "DELETE FROM Customer WHERE CustomerID = @Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", id);

                con.Open();
                try
                {
                    cmd.ExecuteNonQuery();
                }
                catch (SqlException)
                {
                    // Hata olursa (örneðin sipariþi olan müþteri silinmezse) sessizce devam et
                }
            }
            return RedirectToAction("Index");
        }

        // --- GÜNCELLEME SAYFASI (EDIT GET) ---
        [HttpGet]
        public IActionResult Edit(int id)
        {
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                string query = "SELECT * FROM Customer WHERE CustomerID = @Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", id);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            if (dt.Rows.Count == 0) return NotFound();

            return View(dt.Rows[0]);
        }

        // --- GÜNCELLEME ÝÞLEMÝ (EDIT POST) ---
        [HttpPost]
        public IActionResult Edit(int id, string name, string industry, string address, string email, string phone, string taxno)
        {
            using (SqlConnection con = new SqlConnection(_connectionString))
            {
                string query = @"UPDATE Customer SET 
                                CustomerName=@Name, IndustryType=@Industry, Address=@Address, 
                                Email=@Email, PhoneNumber=@Phone, TaxNumber=@TaxNo 
                                WHERE CustomerID=@Id";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", id);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Industry", industry);
                cmd.Parameters.AddWithValue("@Address", address);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@TaxNo", taxno);

                con.Open();
                cmd.ExecuteNonQuery();
            }
            return RedirectToAction("Index");
        }
    }
}