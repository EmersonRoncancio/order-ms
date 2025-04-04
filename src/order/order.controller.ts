import { Controller, ParseUUIDPipe } from '@nestjs/common';
import { MessagePattern, Payload } from '@nestjs/microservices';
import { OrderService } from './order.service';
import { CreateOrderDto } from './dto/create-order.dto';
import { StatusOrderDto } from './dto/status-order.dto';
import { PaginationDto } from 'src/common/dto/pagination.dto';

@Controller()
export class OrderController {
  constructor(private readonly orderService: OrderService) {}

  @MessagePattern({ cmd: 'createOrder' })
  create(@Payload() createOrderDto: CreateOrderDto) {
    return this.orderService.create(createOrderDto);
  }

  @MessagePattern({ cmd: 'findAllOrder' })
  findAll(@Payload() paginationDto: PaginationDto) {
    console.log('paginationDto', paginationDto);
    return this.orderService.findAll(paginationDto);
  }

  @MessagePattern({ cmd: 'findOneOrder' })
  findOne(@Payload('id', ParseUUIDPipe) id: string) {
    console.log('id', id);
    return this.orderService.findOne(id);
  }

  @MessagePattern({ cmd: 'changeOrderStatus' })
  changeOrderStatus(@Payload() updateOrderDto: StatusOrderDto) {
    return this.orderService.changeOrderStatus(updateOrderDto);
  }
}
