# n=5 model=out iset=I1 prefix14_class=13127
mov S1, P2
cmp P2, P0
cmovge P2, P0
cmovle S1, P0
cmp P1, P3
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
mov S2, P2
cmp P2, P3
cmovl P2, P3
cmovg S2, P3
mov S2, P2
mov P0, P1
