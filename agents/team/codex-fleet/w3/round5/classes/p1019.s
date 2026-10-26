# n=5 model=out iset=I1 prefix14_class=1019
mov S1, P2
cmp S1, P1
cmovle S1, P1
cmovl P1, P2
cmovle P2, S1
mov S0, P0
cmp S0, P3
cmovg S0, P3
cmovg P3, P0
cmp P3, S1
cmovge P2, P3
cmovge P3, S1
mov P0, P3
mov P2, S0
