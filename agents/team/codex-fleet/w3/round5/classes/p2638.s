# n=5 model=out iset=I1 prefix14_class=2638
mov S0, P0
mov S2, P3
cmp P2, P0
cmovg P0, P2
cmovge P2, S0
cmp P1, S2
cmovg P3, P1
mov S0, P0
cmovle S2, P1
cmp P3, P0
cmovl P0, P3
cmovle P3, S0
cmp S2, P2
cmovle P3, S2
