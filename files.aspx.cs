using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Globalization;
using NelAspxLib;

public partial class files : Page
{
    string dataareaid = "";
    string DealerNum = "";
    string UserId = "";
    public string PageName = "";

    private static readonly Dictionary<string, string> IconCollection = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Page.SetDealerSession(ref UserId, ref dataareaid, ref DealerNum);
            LoadIcons();
            string path = Request["folder"];
            PageName = Request["name"];
            if (!string.IsNullOrEmpty(UserId))
            {

                if (!IsPostBack)
                {
                    if (!string.IsNullOrEmpty(path))
                    {
                        DirectoryInfo RootInfo = new DirectoryInfo(Server.MapPath("~/" + path));

                        PopulateTreeView(RootInfo);
                    }

                }
            }
            else
            {
                Response.Write("Ugyldig bruger");
            }
        }
        catch
        {
            Response.Write("Ukendt fejl, kontakt web administrator");
        }
    }

    protected void On_Select(object sender, EventArgs e)
    {
        TreeView tv = (TreeView)sender;
        TreeNode tn1 = tv.SelectedNode;
        tn1.SelectAction = TreeNodeSelectAction.Expand;
        bool exp = tn1.Expanded ?? false;

        if (!exp)
        {
            tn1.Expand();
        }
    }

    protected void On_Expand(object sender, TreeNodeEventArgs e)
    {
        try
        {
            string path = e.Node.Value;

            if (e.Node.ChildNodes.Count > 0)
            {
                if (e.Node.ChildNodes[0].Value == "")
                {
                    e.Node.ChildNodes.RemoveAt(0);
                }
            }

            if (e.Node.ChildNodes.Count == 0)
            {
                IEnumerable<FileInfo> fileInfo = new DirectoryInfo(path).GetFiles().Where(f => !f.Name.EndsWith("db") && !Path.GetFileNameWithoutExtension(f.Name).EndsWith("_Thumb"));

                fileInfo = fileInfo.DistinctBy(s => s.Name);

                foreach (FileInfo file in fileInfo)
                {
                    TreeNode node = NodeSelector(file);

                    if (node != null) e.Node.ChildNodes.Add(node);
                }
            }
        }
        catch
        {
            //Response.Write(err.PropertyValues());
        }
    }

    private TreeNode CreateNodeIMG(FileInfo file)
    {
        string navUrl = new Uri(Server.MapPath("~/")).MakeRelativeUri(new Uri(file.FullName)).ToString();

        byte[] resizedBytes = GetThumbImg(file);

        string b64 = resizedBytes.To64();

        CultureInfo culture = new CultureInfo("Da-dk");
        string cc = Convert.ToDecimal(file.Length).ToString("N0", culture);
        string bb = file.Name + "<br>" + file.CreationTime + "<br>" + cc + " Bytes</div>";

        string text = "<div class=\"IzuzuDiv\"><div><label class=\"IzuzuLabel\" style=\"padding-left:220px; margin-top: 25px;font-family: Tahoma; font-size: 10.5pt;cursor: pointer;\">" + bb + "</label></div><img width=\"200\" height=\"100\" src=\"data:image/jpg;base64," + b64 + "\" /> </div>";

        return new TreeNode
        {
            Text = text,
            Value = file.FullName,
            Target = "_blank",
            NavigateUrl = navUrl
        };
    }

    private TreeNode CreateNodeIcon(FileInfo file)
    {
        string val;
        string ext = file.Extension.RemoveChar('.');
        string navUrl = new Uri(Server.MapPath("~/")).MakeRelativeUri(new Uri(file.FullName)).ToString();

        string b64 = IconCollection.TryGetValue(ext, out val) ? val : "";

        CultureInfo culture = new CultureInfo("Da-dk");
        string cc = Convert.ToDecimal(file.Length).ToString("N0", culture);
        string bb = file.Name + "<br>" + file.CreationTime + "<br>" + cc + " Bytes</div>";

        string text = "<div class=\"IzuzuDiv\" style=\"padding-bottom:20px;\"><div><label class=\"IzuzuLabel\" style=\"margin-top: 15px;padding-left:38px;font-family: Tahoma; font-size: 9pt;cursor: pointer;\">" + bb + "</label></div><img src=\"data:image/jpg;base64," + b64 + "\" /> </div>";

        return new TreeNode
        {
            Text = text,
            Value = file.FullName,
            Target = "_blank",
            NavigateUrl = navUrl
        };
    }

    private TreeNode CreateNode(FileInfo file)
    {
        string navUrl = new Uri(Server.MapPath("~/")).MakeRelativeUri(new Uri(file.FullName)).ToString();
        CultureInfo culture = new CultureInfo("Da-dk");
        string cc = Convert.ToDecimal(file.Length).ToString("N0", culture);

        string text = "<div class=\"IzuzuDiv\"><div><label style=\"font-family: Tahoma; font-size: 10.5pt;cursor: pointer;\">" + file.Name + " - " + file.CreationTime + " - " + cc + " Bytes</label>";

        return new TreeNode
        {
            Text = text,
            Value = file.FullName,
            Target = "_blank",
            NavigateUrl = navUrl
        };
    }

    public byte[] GetThumbImg(FileInfo file)
    {
        byte[] result;
        string fileName = Path.GetFileNameWithoutExtension(file.Name);
        string thumbFile = file.DirectoryName + "\\" + fileName + "_Thumb.jpg";
        bool thumbExists = File.Exists(thumbFile);

        if (thumbExists)
        {
            result = File.ReadAllBytes(thumbFile);
        }
        else
        {
            if (!fileName.EndsWith("_Thumb"))
            {
                result = ResizeImage(file.FullName, new Size(200, 100));
                File.WriteAllBytes(thumbFile, result);
            }
            else
            {
                result = new byte[0];
            }
        }

        return result;
    }

    public static byte[] ResizeImage(string path, Size size)
    {
        System.Drawing.Image imgToResize = System.Drawing.Image.FromFile(path);
        int sourceWidth = imgToResize.Width;
        int sourceHeight = imgToResize.Height;
        float nPercentW = size.Width / (float)sourceWidth;
        //Calculate height with new desired size  
        float nPercentH = size.Height / (float)sourceHeight;
        float nPercent = nPercentH < nPercentW ? nPercentH : nPercentW;

        //New Width  
        int destWidth = (int)(sourceWidth * nPercent);
        //New Height  
        int destHeight = (int)(sourceHeight * nPercent);

        Bitmap b = new Bitmap(destWidth, destHeight);
        Graphics g = Graphics.FromImage(b);
        g.InterpolationMode = InterpolationMode.HighQualityBicubic;

        g.DrawImage(imgToResize, 0, 0, destWidth, destHeight);

        MemoryStream ms = new MemoryStream();

        b.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
        byte[] result = ms.ToArray();

        ms.Dispose();
        g.Dispose();

        return result;
    }

    private void PopulateTreeView(DirectoryInfo dirInfo)
    {
        foreach (DirectoryInfo directory in dirInfo.EnumerateDirectories("*", SearchOption.TopDirectoryOnly))
        {
            TreeNode directoryNode = AddNodeAndDescendents(directory);

            TreeView1.Nodes.Add(directoryNode);
        }
        TreeView1.CollapseAll();
    }

    private TreeNode AddNodeAndDescendents(DirectoryInfo folder)
    {
        TreeNode node = new TreeNode(folder.Name, folder.Name);

        foreach (DirectoryInfo subFolder in folder.GetDirectories())
        {
            TreeNode child = AddNodeAndDescendents(subFolder);
            node.ChildNodes.Add(child);
        }

        foreach (FileInfo file in folder.GetFiles("*").Where(f => !Path.GetFileNameWithoutExtension(f.Name).EndsWith("_Thumb")))
        {
            TreeNode tn = NodeSelector(file);

            if (tn != null) node.ChildNodes.Add(tn);
        }
        return node;
    }

    private TreeNode NodeSelector(FileInfo file)
    {
        TreeNode tn;
        switch (file.Extension.ToLower())
        {
            case ".jpg":
                tn = CreateNodeIMG(file);
                break;
            case ".pdf":
            case ".docx":
            case ".xlsx":
            case ".mp4":
            case ".m4v":
            case ".tif":
                tn = CreateNodeIcon(file);
                break;
            default:
                tn = CreateNode(file);
                break;
        }
        return tn;
    }

    void LoadIcons()
    {
        if (IconCollection.Count == 0)
        {
            DirectoryInfo IconDir = new DirectoryInfo(Server.MapPath("~/IconFiles/"));

            foreach (FileInfo file in IconDir.GetFiles())
            {
                string name = file.Name.Split('_')[0];
                IconCollection.Add(name, File.ReadAllText(file.FullName));
            }
        }
    }
}