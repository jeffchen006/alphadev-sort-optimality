# n=5 model=out iset=I1 prefix14_class=10720
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovle P0, S1
mov S2, P0
mov S0, P3
cmp P2, P3
cmovl P3, P2
cmovg S0, P2
cmp S2, S0
cmovge P0, S0
cmovge S0, S2
cmp P3, P1
cmovle P2, P3
