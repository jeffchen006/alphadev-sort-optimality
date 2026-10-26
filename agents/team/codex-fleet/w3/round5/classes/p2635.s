# n=5 model=out iset=I1 prefix14_class=2635
mov S0, P0
cmp P2, S0
mov S2, P3
cmovge P0, P2
cmovg P2, S0
cmp P1, S2
cmovg P3, P1
cmovle S2, P1
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmovle P3, S0
cmp P2, S2
mov P3, S2
