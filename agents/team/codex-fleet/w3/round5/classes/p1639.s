# n=5 model=out iset=I1 prefix14_class=1639
cmp P1, P0
cmovge S1, P1
mov S0, P2
cmovg P1, P0
cmovl S1, P0
cmp P3, P2
cmovl P2, P3
cmovg S0, P3
mov P3, P1
cmp P1, P2
cmovle P3, P2
cmovge P1, P2
mov P1, S0
mov P2, P3
