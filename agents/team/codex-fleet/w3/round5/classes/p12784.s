# n=5 model=out iset=I1 prefix14_class=12784
cmp P1, P3
cmovl S0, P1
mov S2, P0
cmovle P1, P3
cmovl P3, S0
cmp P2, S2
cmovg S2, P2
cmovge P2, P0
mov P0, P2
cmp P2, P3
cmovge P2, P3
mov P2, P1
cmovl P0, P3
cmovge P3, P0
