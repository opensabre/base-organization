package io.github.opensabre.organization;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * 验证应用同时提供 Knife4j 页面和供网关聚合的 OpenAPI 描述。
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class DocumentationEndpointTest {

    @Value("${local.server.port}")
    private int port;

    /**
     * 文档入口、OpenAPI 描述和 UI 初始化配置必须完整可用。
     */
    @Test
    void shouldExposeKnife4jAndOpenApiDocument() throws Exception {
        try (HttpClient client = HttpClient.newHttpClient()) {
            HttpResponse<String> page = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/doc.html")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            HttpResponse<String> openApi = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/v3/api-docs")).GET().build(),
                    HttpResponse.BodyHandlers.ofString());
            HttpResponse<String> swaggerConfig = client.send(
                    HttpRequest.newBuilder(URI.create("http://localhost:" + port + "/v3/api-docs/swagger-config"))
                            .GET().build(),
                    HttpResponse.BodyHandlers.ofString());

            assertThat(page.statusCode()).isEqualTo(200);
            assertThat(page.body()).contains("webjars/js/app");
            assertThat(openApi.statusCode()).isEqualTo(200);
            assertThat(openApi.body()).contains("\"openapi\"");
            assertThat(swaggerConfig.statusCode()).isEqualTo(200);
            assertThat(swaggerConfig.body()).contains("\"url\":\"/v3/api-docs\"");
        }
    }
}
