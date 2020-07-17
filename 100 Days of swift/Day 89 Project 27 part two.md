# Day 89 - Project 27, part two

- Challenge
    1. Pick any emoji and try creating it using Core Graphics. You should find some easy enough, but for a harder challenge you could also try something like the star emoji. 🙂

        ```swift
        func drawEmoji() {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
            
            let image = renderer.image { context in
                let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10, dy: 10)
                
                context.cgContext.setFillColor(UIColor.yellow.cgColor)
                context.cgContext.setStrokeColor(UIColor.orange.cgColor)
                context.cgContext.setLineWidth(5)
                context.cgContext.addEllipse(in: rectangle)
                
                context.cgContext.translateBy(x: 128, y: 64)
                let leftEye = CGRect(x: 0, y: 0, width: 64, height: 128).insetBy(dx: 10, dy: 10)
                context.cgContext.addEllipse(in: leftEye)
                
                context.cgContext.translateBy(x: 192, y: 0)
                let rightEye = CGRect(x: 0, y: 0, width: 64, height: 128).insetBy(dx: 10, dy: 10)
                context.cgContext.addEllipse(in: rightEye)
                
                context.cgContext.translateBy(x: -155, y: 288)
                let smile = CGRect(x: 0, y: 0, width: 192, height: 5)
                context.cgContext.addRect(smile)
                
                
                context.cgContext.drawPath(using: .fillStroke)
            }
            
            imageView.image = image
        }
        ```

    2. Use a combination of **`move(to:)`** and **`addLine(to:)`** to create and stroke a path that spells “TWIN” on the canvas.

        ```swift
        func drawTwin() {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
            
            let image = renderer.image { context in
                
                let length: CGFloat = 64

                context.cgContext.move(to: CGPoint(x: 10, y: 100))
                context.cgContext.addLine(to: CGPoint(x: 10 + length, y: 100))
                
                context.cgContext.move(to: CGPoint(x: 42, y: 100))
                context.cgContext.addLine(to: CGPoint(x: 42, y: 100 + length))
                
                context.cgContext.move(to: CGPoint(x: 90, y: 100))
                context.cgContext.addLine(to: CGPoint(x: 90 + 10, y: 100 + length))
                
                context.cgContext.move(to: CGPoint(x: 90 + 10, y: 100 + length))
                context.cgContext.addLine(to: CGPoint(x: 90 + 30, y: 100))
                
                context.cgContext.move(to: CGPoint(x: 90 + 30, y: 100))
                context.cgContext.addLine(to: CGPoint(x: 90 + 40, y: 100 + length))
                
                context.cgContext.move(to: CGPoint(x: 90 + 40, y: 100 + length))
                context.cgContext.addLine(to: CGPoint(x: 90 + 60, y: 100))
                
                context.cgContext.move(to: CGPoint(x: 170, y: 100))
                context.cgContext.addLine(to: CGPoint(x: 170, y: 100 + length))
                
                context.cgContext.move(to: CGPoint(x: 190, y: 100))
                context.cgContext.addLine(to: CGPoint(x: 190, y: 100 + length))
                
                context.cgContext.move(to: CGPoint(x: 190, y: 100))
                context.cgContext.addLine(to: CGPoint(x: 220, y: 100 + length))
                
                context.cgContext.addLine(to: CGPoint(x: 220, y: 100))
                
                context.cgContext.setLineWidth(10)
                context.cgContext.setStrokeColor(UIColor.green.cgColor)
                context.cgContext.strokePath()
                
            }
            
            imageView.image = image
        }
        ```

    3. Go back to project 3 and change the way the selected image is shared so that it has some rendered text on top saying “From Storm Viewer”. This means reading the **`size`** property of the original image, creating a new canvas at that size, drawing the image in, then adding your text on top.

        ```swift
        func drawWatermark(image: UIImage) -> UIImage {
            let size = CGSize(width: image.size.width, height: image.size.height)
            
            let renderer = UIGraphicsImageRenderer(size: size)
            
            let finalImage = renderer.image { context in
                image.draw(at: CGPoint(x: 0, y: 0))
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 36),
                    .backgroundColor: UIColor.darkGray,
                    .foregroundColor: UIColor.white
                ]
                
                let string = "From Storm Viewer"
                let attributedString = NSAttributedString(string: string, attributes: attributes)
                
                attributedString.draw(at: CGPoint(x: 10, y: 10))
            }
            
            return finalImage
        }
        ```