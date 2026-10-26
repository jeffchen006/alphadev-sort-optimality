# n=5 model=out iset=I1 prefix14_class=6046
cmp P0, P2
cmovge S0, P0
cmovle S0, P2
cmovle P2, P0
mov S2, S0
cmp P1, P3
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp P1, S0
cmovle S2, P1
cmovg S0, P1
mov S0, P2
cmp S0, P3
