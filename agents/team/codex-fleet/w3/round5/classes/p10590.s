# n=5 model=out iset=I1 prefix14_class=10590
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmovg P2, S0
mov S2, P3
cmp P0, S2
cmovge P3, P0
cmovl S2, P0
mov P0, P3
cmp P3, P2
cmovle P3, P2
cmovl P2, P0
cmp P1, S2
mov P0, P2
