using System;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Http;

namespace HedoraSchoolApi.Dtos
{
    public class UserForUpdateDto
    {
        public string PhotoUrl { get; set; }
        public int DivisionId { get; set; }
        public int StandardId { get; set; }
        public string EnrollNo { get; set; }
        public string DisplayName { get; set; }
        public string Dob { get; set; }
        public string GuardianName { get; set; }
        public string BloodGroup { get; set; }
        public string PhoneNumber { get; set; }

    }
}