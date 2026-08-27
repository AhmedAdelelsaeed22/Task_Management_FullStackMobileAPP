using System.Text.RegularExpressions;

namespace DataAccessLayer.Utilities
{
    public class EmailValidating
    {
        public static bool IsValidEmail(string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            string pattern = @"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$";

            return Regex.IsMatch(email, pattern);
        }
    }
}
