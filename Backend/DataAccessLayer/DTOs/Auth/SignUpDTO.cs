namespace DataAccessLayer.DTOs.Auth
{
    public class SignUpDTO
    {
        public string full_name { get; set; } = null!;
        public string user_name { get; set; } = null!;
        public string email_address { get; set; } = null!;
        public string password { get; set; } = null!;
        public string? job_title { get; set; }
    }
}
