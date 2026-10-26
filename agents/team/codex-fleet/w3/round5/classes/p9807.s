# n=5 model=out iset=I1 prefix14_class=9807
mov S0, P3
cmp P1, P3
cmovge P3, P1
mov S2, P2
cmovg P1, S0
cmp P0, S2
cmovl P2, P0
cmovle P0, S2
mov S1, P3
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmp P1, P2
cmovg S0, P1
