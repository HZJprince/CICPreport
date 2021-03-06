USE [master]
GO
/****** Object:  Database [CICPreport]    Script Date: 2016/6/21 星期二 8:49:37 ******/
CREATE DATABASE [CICPreport]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CICPreport', FILENAME = N'D:\database\CICPrep\CICPreport.mdf' , SIZE = 1842176KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CICPreport_log', FILENAME = N'D:\database\CICPrep\CICPreport_log.ldf' , SIZE = 9930624KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CICPreport] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CICPreport].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CICPreport] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CICPreport] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CICPreport] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CICPreport] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CICPreport] SET ARITHABORT OFF 
GO
ALTER DATABASE [CICPreport] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CICPreport] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [CICPreport] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CICPreport] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CICPreport] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CICPreport] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CICPreport] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CICPreport] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CICPreport] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CICPreport] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CICPreport] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CICPreport] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CICPreport] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CICPreport] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CICPreport] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CICPreport] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CICPreport] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [CICPreport] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CICPreport] SET RECOVERY FULL 
GO
ALTER DATABASE [CICPreport] SET  MULTI_USER 
GO
ALTER DATABASE [CICPreport] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CICPreport] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CICPreport] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CICPreport] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'CICPreport', N'ON'
GO
USE [CICPreport]
GO
/****** Object:  Table [dbo].[t_department]    Script Date: 2016/6/21 星期二 8:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_department](
	[c_id] [int] NULL,
	[c_dpt_cde] [varchar](11) NOT NULL,
	[c_dpt_cnm] [varchar](100) NULL,
	[c_dpt_abr] [varchar](12) NULL,
	[c_status] [varchar](1) NULL,
	[c_group] [varchar](4) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_err_record]    Script Date: 2016/6/21 星期二 8:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_err_record](
	[XmlString] [varchar](500) NULL,
	[rqcodeNodes] [varchar](3) NULL,
	[rpcodeNodes] [varchar](3) NULL,
	[errcodeNodes] [varchar](30) NULL,
	[t_work_time] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_fin_cavdoc]    Script Date: 2016/6/21 星期二 8:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_fin_cavdoc](
	[c_dpt_cde] [varchar](11) NOT NULL,
	[n_income] [decimal](20, 2) NOT NULL,
	[t_work_date] [varchar](10) NOT NULL,
	[t_work_time] [datetime] NOT NULL,
	[t_timestamp] [timestamp] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[errrecord]    Script Date: 2016/6/21 星期二 8:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[errrecord]
AS
SELECT   XmlString, rqcodeNodes, rpcodeNodes, errcodeNodes, t_work_time
FROM      dbo.t_err_record
WHERE   (t_work_time >= CONVERT(varchar(12), GETDATE(), 111))


GO
/****** Object:  View [dbo].[IncomeGZH]    Script Date: 2016/6/21 星期二 8:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[IncomeGZH]
AS
SELECT   SUM(dbo.t_fin_cavdoc.n_income) AS Expr1, MAX(dbo.t_fin_cavdoc.t_work_time) AS Expr2
FROM      dbo.t_department INNER JOIN
                dbo.t_fin_cavdoc ON dbo.t_department.c_dpt_cde = dbo.t_fin_cavdoc.c_dpt_cde
WHERE   (dbo.t_fin_cavdoc.c_dpt_cde IN ('440169', '440138', '440159', '440179', '440180', '440187', '440188', '440195', 
                '440198')) AND (dbo.t_fin_cavdoc.t_timestamp IN
                    (SELECT   MAX(t_timestamp) AS Expr1
                     FROM      dbo.t_fin_cavdoc AS t_fin_cavdoc_1
                     GROUP BY c_dpt_cde))


GO
/****** Object:  View [dbo].[IncomeGZS]    Script Date: 2016/6/21 星期二 8:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[IncomeGZS]
AS
SELECT   TOP 100 PERCENT dbo.t_department.c_dpt_cnm, dbo.t_department.c_dpt_cde, dbo.t_department.c_dpt_abr, 
                dbo.t_fin_cavdoc.n_income, dbo.t_fin_cavdoc.t_work_time, dbo.t_department.c_id
FROM      dbo.t_department INNER JOIN
                dbo.t_fin_cavdoc ON dbo.t_department.c_dpt_cde = dbo.t_fin_cavdoc.c_dpt_cde
WHERE   (dbo.t_fin_cavdoc.c_dpt_cde IN ('440138', '440159', '440179', '440180', '440187', '440188', '440169', '440195', '440198', 
                '440148', '440149', '440189', '440191', '440192', '440193')) AND (dbo.t_fin_cavdoc.t_timestamp IN
                    (SELECT   MAX(t_timestamp) AS Expr1
                     FROM      dbo.t_fin_cavdoc AS t_fin_cavdoc_1
                     GROUP BY c_dpt_cde))
ORDER BY dbo.t_department.c_id


GO
/****** Object:  View [dbo].[IncomeQ]    Script Date: 2016/6/21 星期二 8:49:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[IncomeQ]
AS
SELECT   dbo.t_department.c_dpt_cnm, dbo.t_department.c_dpt_cde, dbo.t_department.c_dpt_abr, dbo.t_fin_cavdoc.n_income, 
                dbo.t_fin_cavdoc.t_work_time
FROM      dbo.t_department INNER JOIN
                dbo.t_fin_cavdoc ON dbo.t_department.c_dpt_cde = dbo.t_fin_cavdoc.c_dpt_cde
WHERE   (dbo.t_fin_cavdoc.t_timestamp IN
                    (SELECT   MAX(t_timestamp) AS Expr1
                     FROM      dbo.t_fin_cavdoc AS t_fin_cavdoc_1
                     GROUP BY c_dpt_cde))


GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_t_department_1]    Script Date: 2016/6/21 星期二 8:49:37 ******/
CREATE UNIQUE CLUSTERED INDEX [IX_t_department_1] ON [dbo].[t_department]
(
	[c_dpt_cde] ASC,
	[c_group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_t_fin_cavdoc_3]    Script Date: 2016/6/21 星期二 8:49:37 ******/
CREATE UNIQUE CLUSTERED INDEX [IX_t_fin_cavdoc_3] ON [dbo].[t_fin_cavdoc]
(
	[c_dpt_cde] ASC,
	[t_timestamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_t_department]    Script Date: 2016/6/21 星期二 8:49:37 ******/
CREATE NONCLUSTERED INDEX [IX_t_department] ON [dbo].[t_department]
(
	[c_dpt_cde] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_t_fin_cavdoc]    Script Date: 2016/6/21 星期二 8:49:37 ******/
CREATE NONCLUSTERED INDEX [IX_t_fin_cavdoc] ON [dbo].[t_fin_cavdoc]
(
	[c_dpt_cde] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_t_fin_cavdoc_1]    Script Date: 2016/6/21 星期二 8:49:37 ******/
CREATE NONCLUSTERED INDEX [IX_t_fin_cavdoc_1] ON [dbo].[t_fin_cavdoc]
(
	[t_timestamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_t_fin_cavdoc_2]    Script Date: 2016/6/21 星期二 8:49:37 ******/
CREATE NONCLUSTERED INDEX [IX_t_fin_cavdoc_2] ON [dbo].[t_fin_cavdoc]
(
	[t_work_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [CICPreport] SET  READ_WRITE 
GO
