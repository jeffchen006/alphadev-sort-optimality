# n=5 model=out iset=I1 prefix14_class=9736
mov S0, P2
mov S1, P3
cmp S0, P1
cmovge S0, P1
cmovge P1, P2
cmp P0, P3
cmovle S1, P0
cmovle P0, P3
mov S2, S1
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
cmovge P0, P2
mov P0, P1
