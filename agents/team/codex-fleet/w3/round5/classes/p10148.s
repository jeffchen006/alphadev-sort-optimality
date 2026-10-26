# n=5 model=out iset=I1 prefix14_class=10148
mov S2, P2
cmp P2, P0
mov S1, P3
cmovle S2, P0
cmovl P0, P2
cmp P3, P1
cmovge S1, P1
mov S0, S2
cmovle P3, P1
cmp P3, S2
cmovg S2, P3
cmovge P3, S0
cmp P0, S1
cmovg S0, S1
