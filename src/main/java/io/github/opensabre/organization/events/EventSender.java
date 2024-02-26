//package io.github.opensabre.organization.events;
//
//import io.github.opensabre.organization.config.BusConfig;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.amqp.rabbit.core.RabbitTemplate;
//import org.springframework.amqp.support.converter.MessageConverter;
//import org.springframework.stereotype.Component;
//
//import jakarta.annotation.PostConstruct;
//import jakarta.annotation.Resource;
//
//@Component
//@Slf4j
//public class EventSender {
//
//    @Resource
//    private RabbitTemplate rabbitTemplate;
//
//    @Resource
//    private MessageConverter messageConverter;
//
//    @PostConstruct
//    public void init() {
//        rabbitTemplate.setMessageConverter(messageConverter);
//    }
//
//    public void send(String routingKey, Object object) {
//        log.info("routingKey:{}=>message:{}", routingKey, object);
//        rabbitTemplate.convertAndSend(BusConfig.EXCHANGE_NAME, routingKey, object);
//    }
//}
