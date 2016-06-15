using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Xml;

namespace CICPreport
{
    class RequestUrltest
    {
        public Decimal RequestUrl(string url, String data)//发送方法 
        {
            string returnData = null;
            decimal income = 0;
            //StreamWriter myWriter = null;
            var request = WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = "text/xml";
            //request.Headers.Add("charset:GBK");
            //var encoding = Encoding.GetEncoding("GBK");
            if (data != null)
            {
                byte[] buffer = Encoding.ASCII.GetBytes(data);
                request.ContentLength = buffer.Length;
                request.GetRequestStream().Write(buffer,0,buffer.Length);

                HttpWebResponse webResp = (HttpWebResponse)request.GetResponse();
                Stream answer = webResp.GetResponseStream();
                StreamReader answerData = new StreamReader(answer, Encoding.GetEncoding("GBK"));
                returnData = answerData.ReadToEnd();

                XmlDocument xmldoc = new XmlDocument();
                xmldoc.LoadXml(returnData);
                XmlElement packetElem = xmldoc.DocumentElement;
                XmlNodeList rqcodeNodes = packetElem.GetElementsByTagName("REQUEST_CODE");
                XmlNodeList rpcodeNodes = packetElem.GetElementsByTagName("RESPONSE_CODE");
                XmlNodeList errcodeNodes = packetElem.GetElementsByTagName("ERROR_MESSAGE");    
                XmlNodeList prmsumNodes = packetElem.GetElementsByTagName("PRMSUM");
                if (rpcodeNodes[0].InnerText.ToString() == "E")
                {
                    string sql = "insert into t_err_record values(@XmlString,@rqcodeNodes,@rpcodeNodes,@errcodeNodes,GETDATE())";
                    SQLHelper sqlh = new SQLHelper();
                    sqlh.ExecuteNonQuery(sql, new SqlParameter("@XmlString", data), new SqlParameter("@rqcodeNodes", rqcodeNodes[0].InnerText.ToString()), new SqlParameter("@rpcodeNodes", rpcodeNodes[0].InnerText.ToString()), new SqlParameter("@errcodeNodes", errcodeNodes[0].InnerText.ToString()));
                    income = 0;
                }
                else
                {
                    income = Convert.ToDecimal(prmsumNodes[0].InnerText.ToString());
                }
            }
            else
            {
                income = 0;
            }
            return income;
        }

        public String GetXml(String dpt,String bgndate,String enddate)//要发送的XML 
        {
            XmlDocument doc = new XmlDocument();
            string xml = "<?xml version=\"1.0\" encoding=\"GB2312\"?><PACKET><HEAD><REQUEST_CODE><![CDATA[101]]></REQUEST_CODE><USER_NAME><![CDATA[test]]></USER_NAME><PASSWORD><![CDATA[123456]]></PASSWORD><REQUEST_TIME><![CDATA[20130507161949]]></REQUEST_TIME></HEAD><BODY><C_DPT_CDE>" + dpt + "</C_DPT_CDE><T_BGN_DATE><![CDATA[" + bgndate + "]]></T_BGN_DATE><T_END_DATE><![CDATA[" + enddate + "]]></T_END_DATE></BODY></PACKET>";
            doc.LoadXml(xml);
            return doc.InnerXml.ToString();
        }
    }
}
