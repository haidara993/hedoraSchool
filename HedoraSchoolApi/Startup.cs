using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using HedoraSchoolApi.Data;
using HedoraSchoolApi.Helpers;
using HedoraSchoolApi.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.Hosting;

namespace HedoraSchoolApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddAutoMapper(typeof(AutoMappingProfile));
            services.AddControllers();
            //Config SQL Database
            services.AddDbContext<DataContext>(options =>
             options.UseMySql(Configuration.GetConnectionString("DefaultConnection")));

            //  services.AddTransient<DB_DIEMDANHContext>();


            //JSON
            object p = services.AddControllersWithViews().AddNewtonsoftJson(options =>
                options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            );
            
            IdentityBuilder builder = services.AddIdentityCore<User>(opt =>{
                opt.Password.RequireDigit=false;
                opt.Password.RequiredLength=4;
                opt.Password.RequireNonAlphanumeric=false;
                opt.Password.RequireUppercase=false;
            });

            builder = new IdentityBuilder(builder.UserType,typeof(Role), builder.Services);
            builder.AddEntityFrameworkStores<DataContext>();
            builder.AddRoleValidator<RoleValidator<Role>>();
            builder.AddRoleManager<RoleManager<Role>>();
            builder.AddSignInManager<SignInManager<User>>();
            //Config JWWT
            // var key = Encoding.ASCII.GetBytes(UserService.KEY);
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(option =>{
                option.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey =true,
                    IssuerSigningKey = new SymmetricSecurityKey(System.Text.Encoding.ASCII
                    .GetBytes(Configuration.GetSection("Token:Key").Value)),
                    ValidateIssuer =false,
                    ValidateAudience = false
                };
            });
            services.AddMvc(option =>{
                var policy = new AuthorizationPolicyBuilder().RequireAuthenticatedUser().Build();
                option.Filters.Add(new AuthorizeFilter(policy));
            }).AddJsonOptions(opt => {
                    opt.JsonSerializerOptions.IgnoreReadOnlyProperties = 
                        true;
            });
            services.BuildServiceProvider().GetService<DataContext>().Database.Migrate();
            services.AddCors(options =>
            {
                options.AddPolicy("CorsPolicy", policy =>
                {
                   policy.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin();
                });
            });

            // services.AddScoped<ITokenService,TokenService>();
            // services.AddScoped<IUserRepository,UserRepository>();
            //SCOPE USER SERVICE
            // services.AddScoped<IUserService, UserService>();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            // app.UseHttpsRedirection();

            app.UseRouting();
            
            app.UseCors("CorsPolicy");
            app.UseAuthentication();
            app.UseAuthorization();
            app.UseDefaultFiles();
            app.UseStaticFiles();


            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
