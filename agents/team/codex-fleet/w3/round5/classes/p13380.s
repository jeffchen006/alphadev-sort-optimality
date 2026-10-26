# n=5 model=out iset=I1 prefix14_class=13380
mov S2, P3
cmp P3, P2
mov S0, P1
cmovge P3, P2
cmovg P2, S2
cmp P0, P1
cmovl P1, P0
cmovg S0, P0
cmp P1, P3
cmovle P0, P3
cmovl P3, P1
cmovle P1, P0
cmp P2, S0
cmovge P3, P2
