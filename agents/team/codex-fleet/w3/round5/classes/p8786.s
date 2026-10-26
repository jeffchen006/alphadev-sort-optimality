# n=5 model=out iset=I1 prefix14_class=8786
mov S0, P3
mov S2, P1
cmp P0, P1
cmovle P1, P0
cmovl P0, S2
cmp P2, S0
cmovle S0, P2
cmovg P3, P2
cmp P0, P3
mov S1, P1
cmovge P2, P0
cmovge P0, P3
cmovg P3, P2
cmp P1, S0
