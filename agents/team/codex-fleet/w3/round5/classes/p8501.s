# n=5 model=out iset=I1 prefix14_class=8501
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmovle P0, S1
mov S2, P2
cmp S2, P1
cmovle S2, P1
mov S0, S2
cmovl P1, P2
cmp P0, S2
cmovle S0, P0
cmovge S2, P0
cmp P3, P1
mov P0, P1
