# n=5 model=out iset=I1 prefix14_class=12392
mov S1, P3
cmp P3, P2
cmovge P3, P2
mov S0, P1
cmovle S1, P2
cmp S0, P0
cmovle P1, P0
cmovg S0, P0
cmp S0, P3
mov P2, P3
cmovl P3, S0
cmovge P2, S0
cmp S1, P1
cmovge S0, S1
