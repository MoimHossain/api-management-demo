using System.Diagnostics;
using System.Reflection;

namespace TodoApi
{
    public class SoftwareVersion
    {        public static void Configure(WebApplication? app)
        {
            if (app != null)
            {
                var todoApiGroup = app.MapGroup("software-version");
                var softwareVersionResponse = new SoftwareVersionInfo(
                    typeof(Program).Assembly.GetName().Name,
                    typeof(Program).Assembly.GetName().Version?.ToString(),
                    FileVersionInfo.GetVersionInfo(typeof(Program).Assembly.Location).FileVersion,
                    FileVersionInfo.GetVersionInfo(typeof(Program).Assembly.Location).ProductVersion,
                    8);

                todoApiGroup.MapGet("/", () => softwareVersionResponse).WithName("SoftwareVersion").WithOpenApi();                
            }
        }
    }

    public record SoftwareVersionInfo(string? Assembly, string? AssemblyVersion, string? FileVersion, string? ProductVersion, int InformationalVersion);
}
