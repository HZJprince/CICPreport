using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Data.OleDb;
using System.Timers;
using System.Runtime.InteropServices;
using System.Threading;

namespace CICPreport
{
    class Program
    {
        static void Main(string[] args)
        {
            //int second = 3, count = 39;
            string dptgroup = "4404";
            string minute = DateTime.Now.ToString("mm");
 
            Process[] process;
            IntPtr ParenthWnd = new IntPtr(0);
            IntPtr et = new IntPtr(0);
            Commoncs T = new Commoncs();

            switch (dptgroup)
            {
                case "4400":
                    Console.Title = "中华统计程序-广东";
                    process = Process.GetProcessesByName("CICPreportGD");
                    if (process.Length > 1)
                    {
                        Environment.Exit(0);
                    }
                    
                    ParenthWnd = FindWindow(null, "中华统计程序-广东");
                    ShowWindow(ParenthWnd, 2);
                    
                    T.Timer(3, dptgroup, 38, 0);
                    Console.ReadKey(true);
                    break;
                case "4419":
                    Console.Title = "中华统计程序-东莞";
                    process = Process.GetProcessesByName("CICPreportDG");
                    if (process.Length > 1)
                    {
                        Environment.Exit(0);
                    }

                    ParenthWnd = FindWindow(null, "中华统计程序-东莞");
                    ShowWindow(ParenthWnd, 2);

                    T.Timer(4, dptgroup, 40 ,1);
                    Console.ReadKey(true);
                    break;
                case "4420":
                    Console.Title = "中华统计程序-中山";
                    process = Process.GetProcessesByName("CICPreportZS");
                    if (process.Length > 1)
                    {
                        Environment.Exit(0);
                    }

                    ParenthWnd = FindWindow(null, "中华统计程序-中山");
                    ShowWindow(ParenthWnd, 2);

                    T.Timer(4, dptgroup, 31, 1);
                    Console.ReadKey(true);
                    break;
                case "4404":
                    Console.Title = "中华统计程序-珠海";
                    process = Process.GetProcessesByName("CICPreportZH");
                    if (process.Length > 1)
                    {
                        Environment.Exit(0);
                    }

                    ParenthWnd = FindWindow(null, "中华统计程序-珠海");
                    ShowWindow(ParenthWnd, 2);

                    T.Timer(4, dptgroup, 29, 1);
                    Console.ReadKey(true);
                    break;
            }   
        }

        [DllImport("User32.dll", EntryPoint = "FindWindow")]
        private static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
        [DllImport("user32.dll", EntryPoint = "FindWindowEx")]
        private static extern IntPtr FindWindowEx(IntPtr hwndParent, IntPtr hwndChildAfter, string lpszClass, string lpszWindow);
        [DllImport("User32.dll", EntryPoint = "SendMessage")]
        private static extern int SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, string lParam);
        [DllImport("User32.dll", EntryPoint = "ShowWindow")]
        private static extern bool ShowWindow(IntPtr hWnd, int type);
        
    }
}
