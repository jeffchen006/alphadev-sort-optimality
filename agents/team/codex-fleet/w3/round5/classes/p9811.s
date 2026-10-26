# n=5 model=out iset=I1 prefix14_class=9811
mov S1, P3
cmp P1, S1
cmovg S1, P1
cmovg P1, P3
mov S2, P0
cmp P2, P0
mov S0, S1
cmovl P0, P2
cmovle P2, S2
cmp P2, S0
cmovge S1, P2
cmovge P2, S0
cmp P1, P0
cmovle S2, P0
