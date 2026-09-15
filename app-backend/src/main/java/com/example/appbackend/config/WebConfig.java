package com.example.appbackend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String configuredUploadDir = System.getenv("UPLOAD_DIR");
        String uploadDir = configuredUploadDir == null || configuredUploadDir.isBlank()
                ? System.getProperty("user.dir") + File.separator + "uploads" + File.separator
                : configuredUploadDir;

        // 将头像访问路径映射到可由云端卷覆盖的物理目录。
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(new File(uploadDir).toURI().toString());
    }
}
