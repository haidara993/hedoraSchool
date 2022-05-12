using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HedoraSchoolApi.Models;
using Microsoft.AspNetCore.Identity;
using Newtonsoft.Json;

namespace HedoraSchoolApi.Data
{
    public class Seed
    {
        public static async Task SeedUsers(UserManager<User> _userManager ,RoleManager<Role> _roleManager,DataContext context){
            if (_userManager.Users.Any()) 
            {
                return;
            }
            var userData = System.IO.File.ReadAllText("Data/UserSeedData.json");
            var users = JsonConvert.DeserializeObject<List<User>>(userData);

            var roles = new List<Role> 
            {
                new Role { Name = "Student" },
                new Role { Name = "Admin" },
                new Role { Name = "Teacher" },
                new Role { Name = "Parent" }
            };

            foreach (var role in roles) 
            {
                _roleManager.CreateAsync(role).Wait();
            }

            var standards = new List<Standard> 
            {
                new Standard {StandardName="global",StandardNum=0 },
                new Standard {StandardName="1",StandardNum=1 },
            };

            foreach (var standard in standards) 
            {
                await context.Standards.AddAsync(standard);
                await context.SaveChangesAsync();
            }

            var divisions = new List<Division> 
            {
                new Division {DivisionName="global",DivisionNum=0,StandardId=1 },
                new Division {DivisionName="A",DivisionNum=1,StandardId=2 },
                new Division {DivisionName="B",DivisionNum=2,StandardId=2 },
            };

            foreach (var division in divisions) 
            {
                await context.Divisions.AddAsync(division);
                await context.SaveChangesAsync();
            }

           
            foreach (var user in users)
            {
                _userManager.CreateAsync(user, "password").Wait();
                _userManager.AddToRolesAsync(user, new[] {"Student", "Admin", "Teacher", "Parent"} ).Wait();
            }

            // var adminUser = new User
            // {
            //     UserName = "Admin"
            // };

            // IdentityResult result = _userManager.CreateAsync(adminUser, "password").Result;
            // if (result.Succeeded) 
            // {
            //    var admin = _userManager.FindByNameAsync(adminUser.UserName).Result;
            //    _userManager.AddToRolesAsync(admin, new[] {"Student", "Admin", "Teacher", "Parent"} ).Wait();

            // }

        }

    }
}