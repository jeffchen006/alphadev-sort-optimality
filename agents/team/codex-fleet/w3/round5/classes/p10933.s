# n=5 model=out iset=I1 prefix14_class=10933
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
cmovg S0, P2
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
mov P2, P1
cmovg P0, S1
cmp P0, P2
cmovl P1, P0
cmovge P2, P0
cmp S0, P3
cmovle P0, P3
