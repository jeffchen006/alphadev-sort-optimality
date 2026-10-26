# n=5 model=out iset=I1 prefix14_class=9092
cmp P3, P1
cmovl S2, P3
mov S0, P0
cmovl P3, P1
cmovl P1, S2
cmp S0, P2
cmovle S0, P2
cmovge P0, P2
cmp P0, P1
cmovle S2, P1
cmovl P1, P0
cmovl P0, S2
cmp P3, S0
cmovg S2, P3
