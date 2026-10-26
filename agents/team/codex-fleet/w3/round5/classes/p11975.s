# n=5 model=out iset=I1 prefix14_class=11975
mov S1, P1
cmp P0, P1
cmovg P1, P0
cmovge P0, S1
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
mov S0, P0
cmovl P2, S2
mov S1, P1
cmp P2, S0
cmovl S0, P2
cmovle P2, P0
cmovge P0, P2
