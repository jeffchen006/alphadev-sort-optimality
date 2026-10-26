# n=5 model=out iset=I1 prefix14_class=7920
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P2, P0
cmovge S0, P2
cmovg P2, P0
cmovge P0, S0
cmp P3, P2
cmovg S0, P2
cmovle S0, P3
cmovg P2, P3
cmp P1, P0
mov S0, P1
