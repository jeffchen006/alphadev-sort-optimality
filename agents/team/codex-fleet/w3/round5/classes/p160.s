# n=5 model=out iset=I1 prefix14_class=160
mov S0, P2
cmp P2, P0
cmovge S0, P0
cmovle P2, P0
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
cmp S0, P1
cmovge P0, S0
cmovg S0, P1
cmovl P0, P1
mov S0, P3
cmp P3, P2
