# n=5 model=out iset=I1 prefix14_class=3042
cmp P0, P2
mov S0, P2
cmovle S0, P0
cmovle P0, P2
mov P2, P1
cmp P3, P1
cmovl P1, P3
cmovle P3, P2
cmp S0, P1
cmovg S1, P1
cmovge P1, S0
cmovg S0, S1
mov P2, P0
cmp P3, P2
