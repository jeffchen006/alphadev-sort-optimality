# n=5 model=out iset=I1 prefix14_class=13664
cmp P2, P1
cmovge S2, P1
cmovl S2, P2
cmovle P2, P1
cmp P3, P0
cmovl P1, P3
cmovle P3, P0
mov S1, S2
cmovl P0, P1
cmp P2, P3
cmovg S0, P2
cmovge P2, P3
cmovg P3, S0
cmp P0, S2
