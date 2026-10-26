# n=5 model=out iset=I1 prefix14_class=6827
mov S1, P3
cmp P2, P3
cmovle S1, P2
mov S0, P1
cmovl P2, P3
cmp P1, P0
cmovg S0, P0
cmovle P1, P0
mov P3, P1
cmp P2, P3
cmovl P1, P2
cmovle P2, P3
cmp S1, S0
cmovge P0, S1
