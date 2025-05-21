
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, Index, BaseEntity } from "typeorm";

@Entity()
export class ElectricityPrice extends BaseEntity {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column()
    @Index()
    startsAt: Date = new Date();

    @Column("float")
    totalPrice: number = 0;

    @Column("float")
    energyPrice: number = 0;

    @Column("float")
    taxPrice: number = 0;

    @CreateDateColumn()
    createdAt: Date = new Date();
}
