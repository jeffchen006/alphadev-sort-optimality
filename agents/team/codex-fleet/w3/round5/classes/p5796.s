# n=5 model=out iset=I1 prefix14_class=5796
mov S0, P2
cmp S0, P3
cmovle S0, P3
cmovle P3, P2
cmovge P2, P3
mov S1, P1
cmp S1, P0
cmovge P1, P0
cmovg P0, S1
cmp P3, P1
cmovl P2, P1
cmovl P1, P3
cmp S0, P0
cmovge P3, P0
