# n=5 model=out iset=I1 prefix14_class=12364
cmp P2, P3
cmovle S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P1, P0
cmovle S0, P0
cmovg S0, P1
cmovge P1, P0
cmp P3, P1
cmovle S2, P3
cmovle P3, P1
cmovle P1, S2
mov P1, S0
cmp S0, P2
