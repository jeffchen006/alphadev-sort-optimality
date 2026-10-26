# n=5 model=out iset=I1 prefix14_class=6932
cmp P0, P2
cmovg S0, P0
cmovle S0, P2
cmovge P0, P2
cmp P3, P1
cmovge S1, P3
cmovl S1, P1
cmovle P1, P3
cmp S0, S1
cmovle P3, S1
cmovl S1, S0
cmovle S0, P3
cmp P0, P1
mov P2, P1
