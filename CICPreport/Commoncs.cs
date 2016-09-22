using System;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading;
using System.Timers;
using System.Xml;

namespace CICPreport
{
    class Commoncs
    {
        static int i = 1, z;
        static int count;
        static string group = "";
        static System.Timers.Timer aTimer = new System.Timers.Timer();

        public void Timer(int seconds,string groupid,int countid,int strnum)
        {
            #region 定时器事件
            group = groupid;
            count = countid;
            z = strnum;
            aTimer.Interval = seconds * 1000;    //配置文件中配置的秒数
            aTimer.Enabled = true;
            aTimer.Start();
            aTimer.Elapsed += new ElapsedEventHandler(Report);
            #endregion
        }

        public static void Report(object source, ElapsedEventArgs e)
        {
            int intHour = e.SignalTime.Hour;
            //string intHour = DateTime.Now.ToString("HH");
            int intMinute = e.SignalTime.Minute;
            //int intSecond = e.SignalTime.Second;
            if (intHour >= 24 || intHour <= 6)
            {
                Thread.Sleep(32400000);
            }
            else if (z == 0)
            {
                if (i > count)
                {
                    if (group != "4400")
                    {
                        z = z + 1;
                    }
                    else
                    {
                        i = 1;
                    }
                }
                else
                {
                    string date = DateTime.Now.ToString("yyyy-MM-dd");
                    string bgndate = DateTime.Now.ToString("yyyyMMdd");
                    string enddate = DateTime.Now.AddDays(1).ToString("yyyMMdd");
                    //string datetime = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
                    //全省：
                    string sql = "select c_dpt_cde from t_department where c_id = @c_id and c_group = @c_group and c_status = 1";
                    //MSSQL格式:
                    string sqlinsert = "insert into t_fin_cavdoc values(@c_dpt_cde,@n_income,@t_work_date,GETDATE(),DEFAULT)";
                    //string sqlinsert = "insert into t_fin_cavdoc values(?,?,?,?)";
                    SQLHelper sqlh = new SQLHelper();

                    object dpt = sqlh.ExecuteScalar(sql, new SqlParameter("@c_id", i), new SqlParameter("@c_group", group));
                    RequestUrltest xml = new RequestUrltest();
                    //string WebUrl = "http://10.196.20.15:8001/webappEB/aoutclaim";//测试环境URL
                    string WebUrl = "http://10.192.0.16:7001/webapp/aoutclaim";//正式环境URL

                    String getxml = xml.GetXml(Convert.ToString(dpt), bgndate, enddate);
                    Decimal income = xml.RequestUrl(WebUrl, getxml);
                    int status = sqlh.ExecuteNonQuery(sqlinsert, new SqlParameter("@c_dpt_cde", dpt.ToString()), new SqlParameter("@n_income", income), new SqlParameter("@t_work_date", date));
                    i = i + 1;
                    Console.WriteLine("机构：" + Convert.ToString(dpt) + ",日期：" + date + ",保费：" + income + ",状态：" + status);
                }
            }
            else if (group != "4400" && (intMinute == 0 || intMinute == 15 || intMinute == 30 || intMinute == 45))
            {
                z = 0; i = 1;
            } 
        }
    }
}
