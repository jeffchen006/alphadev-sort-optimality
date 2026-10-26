# n=5 model=out iset=I1 prefix14_class=6150
mov S1, P1
cmp P2, P3
mov S0, P3
cmovge S0, P2
cmovge P2, P3
cmp S1, P0
cmovle P1, P0
cmovge S1, P0
mov P0, S0
cmp S0, P1
cmovge P0, P1
cmovge P1, S0
cmovg S0, P0
mov P1, S1
