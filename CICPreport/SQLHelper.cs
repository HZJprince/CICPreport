using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data;
using System.Data.OleDb;

namespace CICPreport
{
    class SQLHelper
    {
        public object ExecuteScalar(string sql, params SqlParameter[] parameteres)
        {
            string ConStr = ConfigurationManager.ConnectionStrings["CICRep"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(ConStr))
            {
                conn.Open();
                using (SqlCommand ConCmd = conn.CreateCommand())
                {
                    ConCmd.CommandText = sql;
                    foreach (SqlParameter param in parameteres)
                    {
                        ConCmd.Parameters.Add(param);
                    }
                    object i = ConCmd.ExecuteScalar();
                    conn.Close();
                    return i;
                }
                
            }
        }

        public int ExecuteNonQuery(string sql, params SqlParameter[] parameteres)
        {
            string ConStr = ConfigurationManager.ConnectionStrings["CICRep"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(ConStr))
            {
                conn.Open();
                using (SqlCommand ConCmd = conn.CreateCommand())
                {
                    ConCmd.CommandText = sql;
                    foreach (SqlParameter param in parameteres)
                    {
                        ConCmd.Parameters.Add(param);
                    }
                    int i = ConCmd.ExecuteNonQuery();
                    conn.Close();
                    return i;
                }
            }
        }

        public object ExecuteScalarO(string sql, params OleDbParameter[] parameteres)
        {
            string ConStr = ConfigurationManager.ConnectionStrings["CICRepI"].ConnectionString;
            using (OleDbConnection conn = new OleDbConnection(ConStr))
            {
                conn.Open();
                using (OleDbCommand ConCmd = conn.CreateCommand())
                {
                    ConCmd.CommandText = sql;
                    foreach (OleDbParameter param in parameteres)
                    {
                        ConCmd.Parameters.Add(param);
                    }
                    return ConCmd.ExecuteScalar();
                }
            }
        }

        public int ExecuteNonQueryO(string sql, params OleDbParameter[] parameteres)
        {
            string ConStr = ConfigurationManager.ConnectionStrings["CICRepI"].ConnectionString;
            using (OleDbConnection conn = new OleDbConnection(ConStr))
            {
                conn.Open();
                using (OleDbCommand ConCmd = conn.CreateCommand())
                {
                    ConCmd.CommandText = sql;
                    foreach (OleDbParameter param in parameteres)
                    {
                        ConCmd.Parameters.Add(param);
                    }
                    return ConCmd.ExecuteNonQuery();
                }
            }
        }
    }
}
