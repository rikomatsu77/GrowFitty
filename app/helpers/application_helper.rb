module ApplicationHelper
  def default_meta_tags
    {
      site: "GrowFitty",
      title: "子ども服サイズ予測アプリ",
      reverse: true,
      charset: "utf-8",
      separator: " | ",
      description: "子どもの成長に合わせて最適な服のサイズを予測。ぴったりサイズで無駄のないお買い物をサポートします。",
      keywords: "GrowFitty,子ども服,サイズ予測,育児,子育て,服選び,成長記録",
      canonical: "https://growfitty.onrender.com/",
      og: {
        site_name: "GrowFitty",
        title: :title,
        description: :description,
        type: "website",
        url: "https://growfitty.onrender.com/",
        image: image_url("GrowFitty-ogp.png"),
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@rikopin_61b",
        image: image_url("GrowFitty-ogp.png")
      }
    }
  end
end
