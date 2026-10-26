# n=5 model=out iset=I1 prefix14_class=3043
cmp P0, P2
mov S2, P2
cmovle S2, P0
cmovle P0, P2
mov P2, P1
cmp P3, P1
cmovl P1, P3
mov S0, P0
cmovle P3, P2
cmp S2, P1
cmovge P2, P1
cmovge P1, S2
cmovg S2, P2
cmp P3, S0
