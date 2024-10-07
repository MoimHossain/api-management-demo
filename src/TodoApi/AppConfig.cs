namespace TodoApi
{
    public class AppConfig
    {
        private const string APPINSIGHT_CONN_STR_KEY = "APPINSIGHT_CONN_STR";

        public static string? GetAppInsightsConnStrFromEnv()
        {
            return System.Environment.GetEnvironmentVariable(APPINSIGHT_CONN_STR_KEY);
        }
    }
}
