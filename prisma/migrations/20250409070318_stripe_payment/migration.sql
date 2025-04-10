/*
  Warnings:

  - The values [CONFIRMED] on the enum `OrderStatus` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "OrderStatus_new" AS ENUM ('PENDING', 'PAID', 'DELIVERED', 'CANCELLED');
ALTER TABLE "Order" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "Order" ALTER COLUMN "status" TYPE "OrderStatus_new" USING ("status"::text::"OrderStatus_new");
ALTER TABLE "Order" ALTER COLUMN "orderItem" TYPE "OrderStatus_new"[] USING ("orderItem"::text::"OrderStatus_new"[]);
ALTER TYPE "OrderStatus" RENAME TO "OrderStatus_old";
ALTER TYPE "OrderStatus_new" RENAME TO "OrderStatus";
DROP TYPE "OrderStatus_old";
ALTER TABLE "Order" ALTER COLUMN "status" SET DEFAULT 'PENDING';
COMMIT;

-- AlterTable
ALTER TABLE "Order" ADD COLUMN     "stripeId" TEXT;

-- CreateTable
CREATE TABLE "Receipt" (
    "id" TEXT NOT NULL,
    "receiptUrl" TEXT NOT NULL,
    "orderId" TEXT NOT NULL,

    CONSTRAINT "Receipt_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Receipt_orderId_key" ON "Receipt"("orderId");

-- AddForeignKey
ALTER TABLE "Receipt" ADD CONSTRAINT "Receipt_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
