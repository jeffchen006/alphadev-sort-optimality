# n=5 model=out iset=I1 prefix14_class=11279
mov S1, P1
cmp P3, S1
cmovle S1, P3
cmovl P3, P1
cmp P2, P0
cmovle S0, P0
cmovge S0, P2
cmovge P2, P0
mov S2, S1
cmp S0, P3
cmovle P0, P3
cmovle P3, S0
cmovle S0, P0
mov S0, P3
