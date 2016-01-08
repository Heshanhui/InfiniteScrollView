# InfiniteScrollView
Swift实现的 图片轮播器

直接传入图片数组,即可创建自动轮播的图片轮播器


    // MARK: - 懒加载图片展示的view
    lazy var infiniteScrollView : HSHInfiniteScrollView = {

        let infiniteScrollView = HSHInfiniteScrollView(images: ["image1", "image2", "image3", "image4", "image5"], imageSelectCallBack: { (index) -> () in
            // 在此执行点击图片的动作 index为图片数组下标
            print(index)
        })
        // 设置此参数可以调整图片滚动方向
        infiniteScrollView.scrollDirectionLandscape = false
        return infiniteScrollView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 设置图片滚动器的frame即可
        infiniteScrollView.frame = CGRect(x: 50, y: 100, width: 300, height: 180)
        view.addSubview(infiniteScrollView)
        
    }
