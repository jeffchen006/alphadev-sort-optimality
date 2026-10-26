# n=5 model=out iset=I1 prefix14_class=12318
cmp P3, P0
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
mov S1, P2
cmp S1, P1
cmovle S1, P1
cmovl P1, P2
cmp P1, P3
mov P2, P3
cmovl P2, P1
cmovge P3, P1
cmp S1, P0
cmovl S0, P0
